module EyeTrackedHUD

enum HUDZone {
    None = 0,
    TopLeft = 1,
    TopRight = 2,
    BottomLeft = 3,
    BottomRight = 4,
    UpperMiddleRight = 5,
    LowerMiddleRight = 6
}

@addMethod(inkGameController)
public func SetupTobiiTracking(zone: HUDZone) -> Void {
    let player = this.GetPlayerControlledObject();
    if IsDefined(player) {
        GameInstance.GetDelaySystem(player.GetGame()).DelayCallback(
            TobiiHudRefreshCallback.Create(this, null, zone), 
            0.02,
            false
        );
    }
}
@addMethod(gameuiNewPhoneRelatedHUDGameController)
public func SetupTobiiTrackingPhoneHUD(zone: HUDZone) -> Void {
    let player = this.GetPlayerControlledObject();
    if IsDefined(player) {
        GameInstance.GetDelaySystem(player.GetGame()).DelayCallback(
            TobiiHudRefreshCallback.Create(null, this, zone), 
            0.02, 
            false
        );
    }
}

// ==========================================
// 3D QUEST MARKER TRANSPARENCY
// ==========================================
@wrapMethod(QuestMappinController)
protected cb func OnUpdate() -> Bool {
    wrappedMethod();

    if !EyeTrackedHUDConfig.is3DMarkerTransparencyEnabled() {
        return true;
    }

    let opacityFactor : Float = 0.08;

    if inkImageRef.IsValid(this.iconWidget) {
        inkImageRef.SetOpacity(this.iconWidget, 1.0 * opacityFactor);
    }
    if inkTextRef.IsValid(this.distanceText) {
        inkTextRef.SetOpacity(this.distanceText, 1.0 * opacityFactor);
    }
    if inkTextRef.IsValid(this.displayName) {
        inkTextRef.SetOpacity(this.displayName, 1.0 * opacityFactor);
    }
    
    return true;
}

// ==========================================
// STAMINA AUTO-FADE CONFLICT OVERRIDE
// ==========================================
@replaceMethod(StaminabarWidgetGameController)
public func EvaluateStaminaBarVisibility() -> Void {
    let root = this.GetRootWidget();
    if !IsDefined(root) { return; }

    if Equals(this.m_sceneTier, GameplayTier.Tier4_FPPCinematic)
    || Equals(this.m_sceneTier, GameplayTier.Tier5_Cinematic)
    || NotEquals(this.m_sceneTier, GameplayTier.Tier1_FullGameplay)
    || this.m_currentBarValue >= 1.0 {
        root.SetVisible(false);
    } else {
        root.SetVisible(true);
    }
}

// ==========================================
// TARGET HOOKS
// ==========================================
// --- TOP LEFT ZONE ---
@wrapMethod(healthbarWidgetGameController)
protected cb func OnInitialize() -> Bool {
    let result = wrappedMethod();
    this.SetupTobiiTracking(HUDZone.TopLeft);
    return result;
}
@wrapMethod(StaminabarWidgetGameController)
protected cb func OnInitialize() -> Bool {
    let result = wrappedMethod();
    this.SetupTobiiTracking(HUDZone.TopLeft);
    return result;
}
@wrapMethod(buffListGameController)
protected cb func OnInitialize() -> Bool {
    let result = wrappedMethod();
    this.SetupTobiiTracking(HUDZone.TopLeft);
    return result;
}

// --- BOTTOM LEFT ZONE ---
@wrapMethod(GenericHotkeyController)
protected func Initialize() -> Bool {
    let result = wrappedMethod();
    
    if Equals(this.m_hotkey, EHotkey.RB)
    || Equals(this.m_hotkey, EHotkey.DPAD_UP)
    || Equals(this.m_hotkey, EHotkey.DPAD_DOWN)
    || Equals(this.m_hotkey, EHotkey.DPAD_RIGHT) {
        this.SetupTobiiTrackingPhoneHUD(HUDZone.BottomLeft);
    }
    return result;
}
@wrapMethod(RadioHotkeyController)
protected cb func OnPlayerAttach(player: ref<GameObject>) -> Void {
    wrappedMethod(player);
    this.SetupTobiiTrackingPhoneHUD(HUDZone.BottomLeft);
}
@wrapMethod(AutoDriveController)
protected cb func OnInitialize() -> Void {
    wrappedMethod();
    this.SetupTobiiTracking(HUDZone.BottomLeft);
}
@wrapMethod(vehicleVisualCustomizationHotkeyController)
protected func Initialize() -> Bool {
    let result = wrappedMethod();
    this.SetupTobiiTrackingPhoneHUD(HUDZone.BottomLeft);
    return result;
}
@wrapMethod(hudCarController)
protected cb func OnInitialize() -> Bool {
    let result = wrappedMethod();
    this.SetupTobiiTracking(HUDZone.BottomLeft);
    return result;
}

// --- TOP RIGHT ZONE ---
@wrapMethod(MinimapContainerController)
protected cb func OnInitialize() -> Bool {
    let result = wrappedMethod();
    this.SetupTobiiTracking(HUDZone.TopRight);
    return result;
}
@wrapMethod(WantedBarGameController)
protected cb func OnInitialize() -> Bool {
    let result = wrappedMethod();
    this.SetupTobiiTracking(HUDZone.TopRight);
    return result;
}

// --- UPPER MIDDLE RIGHT ZONE ---
@wrapMethod(QuestTrackerGameController)
protected cb func OnInitialize() -> Bool {
    let result = wrappedMethod();
    this.SetupTobiiTracking(HUDZone.UpperMiddleRight);
    return result;
}

// --- LOWER MIDDLE RIGHT ZONE ---
@addMethod(InputHintManagerGameController)
protected cb func OnInitialize() -> Void {
    this.SetupTobiiTracking(HUDZone.LowerMiddleRight);
}

// --- BOTTOM RIGHT ZONE ---
@wrapMethod(WeaponRosterGameController)
protected cb func OnInitialize() -> Bool {
    let result = wrappedMethod();
    this.SetupTobiiTracking(HUDZone.BottomRight);
    return result;
}
@wrapMethod(CrouchIndicatorGameController)
protected cb func OnPlayerAttach(player: ref<GameObject>) -> Void {
    wrappedMethod(player);
    this.SetupTobiiTracking(HUDZone.BottomRight);
}

public class TobiiHudRefreshCallback extends DelayCallback {
    private let m_controller: wref<inkGameController>;
    private let m_phoneController: wref<gameuiNewPhoneRelatedHUDGameController>;
    private let m_zone: HUDZone;

    public static func Create(target: ref<inkGameController>, phoneTarget: ref<gameuiNewPhoneRelatedHUDGameController>, targetZone: HUDZone) -> ref<TobiiHudRefreshCallback> {
        let self = new TobiiHudRefreshCallback();
        self.m_controller = target;
        self.m_phoneController = phoneTarget;
        self.m_zone = targetZone;
        return self;
    }

    public func Call() -> Void {
        let gaze: Vector2 = TobiiHardwareInterface.GetGazeCoordinates();
        let shouldBeVisible: Bool = false;
        let zone: EyeZone;

        switch this.m_zone {
            case HUDZone.TopLeft:          zone = EyeTrackedHUDConfig.GetTopLeft(); break;
            case HUDZone.TopRight:         zone = EyeTrackedHUDConfig.GetTopRight(); break;
            case HUDZone.UpperMiddleRight: zone = EyeTrackedHUDConfig.GetUpperMiddleRight(); break;
            case HUDZone.LowerMiddleRight: zone = EyeTrackedHUDConfig.GetLowerMiddleRight(); break;
            case HUDZone.BottomLeft:       zone = EyeTrackedHUDConfig.GetBottomLeft(); break;
            case HUDZone.BottomRight:      zone = EyeTrackedHUDConfig.GetBottomRight(); break;
            default: return;
        }

        shouldBeVisible = gaze.X >= zone.xMin && gaze.X <= zone.xMax && gaze.Y >= zone.yMin && gaze.Y <= zone.yMax;

        let targetOpacity: Float = shouldBeVisible ? 1.0 : 0.0;

        let currentOpacity: Float = 0.0;
        let hasWidget: Bool = false;
        let isAutoDrive: Bool = false;
        
        let rootWidget: ref<inkWidget> = null;
        let parentWidget: ref<inkWidget> = null;
        let contentWidget: ref<inkWidget> = null;
        let hintWidget: ref<inkWidget> = null;

        if IsDefined(this.m_controller) {
            let autoDriveCtrl = this.m_controller as AutoDriveController;
            if IsDefined(autoDriveCtrl) {
                isAutoDrive = true;
                contentWidget = inkWidgetRef.Get(autoDriveCtrl.m_autoDriveContentContainer);
                hintWidget = inkWidgetRef.Get(autoDriveCtrl.m_inputHintContainer);
                if IsDefined(contentWidget) {
                    currentOpacity = contentWidget.GetOpacity();
                    hasWidget = true;
                }
            } else {
                rootWidget = this.m_controller.GetRootWidget();
                if IsDefined(rootWidget) {
                    currentOpacity = rootWidget.GetOpacity();
                    hasWidget = true;
                }
            }
        } else if IsDefined(this.m_phoneController) {
            rootWidget = this.m_phoneController.GetRootWidget();
            if IsDefined(rootWidget) {
                currentOpacity = rootWidget.GetOpacity();
                parentWidget = rootWidget.GetParentWidget();
                hasWidget = true;
            }
        }

        if hasWidget {
            let step: Float = 0.15;
            let nextOpacity: Float = currentOpacity;

            if currentOpacity < targetOpacity {
                nextOpacity = currentOpacity + step;
                if nextOpacity > targetOpacity { nextOpacity = targetOpacity; }
            } else if currentOpacity > targetOpacity {
                nextOpacity = currentOpacity - step;
                if nextOpacity < targetOpacity { nextOpacity = targetOpacity; }
            }

            if IsDefined(this.m_controller) {
                if isAutoDrive {
                    if IsDefined(contentWidget) { contentWidget.SetOpacity(nextOpacity); }
                    if IsDefined(hintWidget) { hintWidget.SetOpacity(nextOpacity); }
                } else {
                    if IsDefined(rootWidget) { rootWidget.SetOpacity(nextOpacity); }
                }
            } else if IsDefined(this.m_phoneController) {
                if IsDefined(rootWidget) { rootWidget.SetOpacity(nextOpacity); }
                if IsDefined(parentWidget) { parentWidget.SetOpacity(nextOpacity); }
            }
        }

        if IsDefined(this.m_controller) {
            this.m_controller.SetupTobiiTracking(this.m_zone);
        } else if IsDefined(this.m_phoneController) {
            this.m_phoneController.SetupTobiiTrackingPhoneHUD(this.m_zone);
        }
    }
}