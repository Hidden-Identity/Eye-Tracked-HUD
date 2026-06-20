module EyeTrackedHUD

public class TobiiHardwareInterface {
    public static func GetGazeCoordinates() -> Vector2 {
        let gaze: Vector2;

        let nativeFunc = Reflection.GetGlobalFunction(n"GetTobiiGaze");

        if IsDefined(nativeFunc) {
            let emptyArgs: array<Variant>;
            let resultContainer = nativeFunc.Call(emptyArgs);

            gaze = FromVariant(resultContainer);
        } else {
            // Fallback if the hardware or native binding is offline
            gaze.X = -1.0;
            gaze.Y = -1.0;
        }

        return gaze;
    }
}