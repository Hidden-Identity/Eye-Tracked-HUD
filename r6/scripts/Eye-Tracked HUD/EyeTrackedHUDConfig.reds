module EyeTrackedHUD

public struct EyeZone {
    public let xMin: Float;
    public let xMax: Float;
    public let yMin: Float;
    public let yMax: Float;
}

// =============================================================================
// EYE-TRACKED HUD ZONE CONFIGURATION
// =============================================================================
// The mod uses a normalized coordinate system (0.0 to 1.0 for both X and Y axes) to define zones on the screen:
//
//                            Y=0.0
//            +-----------------------------------+ 
//            |                                   |
//            |                                   |
//            |                                   |
//      X=0.0 |       (Center X=0.5, Y=0.5)       | X=1.0
//            |                                   |
//            |                                   |
//            |                                   |
//            +-----------------------------------+
//                            Y=1.0
//
// - The default values match a 16:9 aspect ratio. You may adjust the zone boundaries as needed in the class EyeTrackedHUDConfig.
// - Values outside 0.0-1.0 are also valid (e.g. -0.1/1.1 to show elements when looking slightly beyond screen size).
//
//   Example: if you set the Top-Right zone (minimap and wanted bar) to:
//      zone.xMin = 0.66; zone.xMax = 1.0;
//      zone.yMin =  0.0; zone.yMax = 0.5;
//   that zone's elements will appear when looking at this part of the screen:
//
//                                      yMin=0.0
//            +-----------------------+-----------+
//            |                       |           |
//            |              xMin=0.66|           |xMax=1.0
//            |                       |           |
//            |                       +-----------|
//            |                         yMax=0.5  |
//            |                                   |
//            |                                   |
//            +-----------------------------------+
//
// =============================================================================
public class EyeTrackedHUDConfig {
    // Health Bar, Stamina Bar & Buff List
    public static func GetTopLeft() -> EyeZone {
        let zone: EyeZone;
        zone.xMin = -0.1; zone.xMax = 0.28;
        zone.yMin = -0.1; zone.yMax = 0.17;
        return zone;
    }

    // Minimap & Wanted Bar
    public static func GetTopRight() -> EyeZone {
        let zone: EyeZone;
        zone.xMin = 0.82; zone.xMax = 1.1;
        zone.yMin = -0.1; zone.yMax = 0.33;
        return zone;
    }

    // Active Quest & Objectives
    public static func GetUpperMiddleRight() -> EyeZone {
        let zone: EyeZone;
        zone.xMin = 0.77; zone.xMax = 1.1;
        zone.yMin = 0.24; zone.yMax = 0.54;
        return zone;
    }

    // Input Hints
    public static func GetLowerMiddleRight() -> EyeZone {
        let zone: EyeZone;
        zone.xMin = 0.77; zone.xMax = 1.1;
        zone.yMin = 0.67; zone.yMax = 0.90;
        return zone;
    }

    // Phone, Items, D-pad Actions, Autodrive Information & 3rd-Person Speedometer
    public static func GetBottomLeft() -> EyeZone {
        let zone: EyeZone;
        zone.xMin = -0.1; zone.xMax = 0.23;
        zone.yMin = 0.70; zone.yMax = 1.1;
        return zone;
    }

    // Equipped Weapon & Crouch Indicator
    public static func GetBottomRight() -> EyeZone {
        let zone: EyeZone;
        zone.xMin = 0.70; zone.xMax = 1.1;
        zone.yMin = 0.80; zone.yMax = 1.1;
        return zone;
    }

    // ======= MISCELLANEOUS =======
    // This option heavily reduces the opacity of all 3d markers in order for them to not stick out like sore thumbs in a clean HUD.
    // 
    // to enable, set return true;
    // to disable, set return false;
    // =============================
    public static func is3DMarkerTransparencyEnabled() -> Bool {
        return true;
    }
}
