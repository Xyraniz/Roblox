/* =============================================================
/*                       theo's offsets                         
/*                  https://offsets.imtheo.lol                  
/* -------------------------------------------------------------
/*  Dumped With     : RbxDumperV2                               
/*  Source code     : https://git.imtheo.lol/theo/RbxDumperV2   
/*  Roblox Version  : version-11f155f3450f4c8e
/*  Dumper Version  : 2.2.4
/*  Dumped At       : 19:22 15/10/2026 (GMT)
/*  Total Offsets   : 392
/* -------------------------------------------------------------
/*  Join the discord!                                           
/*  https://offsets.imtheo.lol/discord                          
/* =============================================================
*/

namespace Offsets {
    public static class Info {
        public static string ClientVersion = "version-11f155f3450f4c8e";
    }

    public static class AirProperties {
         public const long AirDensity = 0x18;
         public const long GlobalWind = 0x3c;
    }

    public static class AnimationTrack {
         public const long Animation = 0xa8;
         public const long Animator = 0x100;
         public const long IsPlaying = 0xa48;
         public const long Looped = 0xd5;
         public const long Speed = 0xc4;
         public const long TimePosition = 0xc8;
    }

    public static class Animator {
         public const long ActiveAnimations = 0xa80;
    }

    public static class Atmosphere {
         public const long Color = 0xa8;
         public const long Decay = 0xb4;
         public const long Density = 0xc0;
         public const long Glare = 0xc4;
         public const long Haze = 0xc8;
         public const long Offset = 0xcc;
    }

    public static class Attachment {
         public const long Position = 0xb4;
    }

    public static class BasePart {
         public const long CastShadow = 0x128;
         public const long Color3 = 0x39;
         public const long Locked = 0x129;
         public const long Massless = 0x12a;
         public const long Primitive = 0x180;
         public const long Reflectance = 0xfc;
         public const long Shape = 0x1a8;
         public const long Transparency = 0x120;
    }

    public static class Beam {
         public const long Attachment0 = 0x150;
         public const long Attachment1 = 0x160;
         public const long Brightness = 0x170;
         public const long CurveSize0 = 0x174;
         public const long CurveSize1 = 0x178;
         public const long LightEmission = 0x17c;
         public const long LightInfluence = 0x180;
         public const long Texture = 0x130;
         public const long TextureLength = 0x18c;
         public const long TextureSpeed = 0x194;
         public const long Width0 = 0x198;
         public const long Width1 = 0x19c;
         public const long ZOffset = 0x1a0;
    }

    public static class BloomEffect {
         public const long Enabled = 0xa0;
         public const long Intensity = 0xa8;
         public const long Size = 0xac;
         public const long Threshold = 0xb0;
    }

    public static class BlurEffect {
         public const long Enabled = 0xa0;
         public const long Size = 0xa8;
    }

    public static class ByteCode {
         public const long Pointer = 0x10;
         public const long Size = 0x28;
    }

    public static class CachedItem {
         public const long FileMeshData = 0x40;
    }

    public static class Camera {
         public const long CameraSubject = 0xb8;
         public const long CameraType = 0x128;
         public const long FieldOfView = 0x130;
         public const long ImagePlaneDepth = 0x2d4;
         public const long Position = 0xec;
         public const long Rotation = 0xc8;
         public const long Viewport = 0x28c;
         public const long ViewportSize = 0x2cc;
    }

    public static class CharacterMesh {
         public const long BaseTextureId = 0xb8;
         public const long BodyPart = 0x138;
         public const long MeshId = 0xe8;
         public const long OverlayTextureId = 0x118;
    }

    public static class ClickDetector {
         public const long MaxActivationDistance = 0xd8;
         public const long MouseIcon = 0xb8;
    }

    public static class Clothing {
         public const long Color3 = 0x110;
         public const long Template = 0xf0;
    }

    public static class ColorCorrectionEffect {
         public const long Brightness = 0xb4;
         public const long Contrast = 0xb8;
         public const long Enabled = 0xa0;
         public const long TintColor = 0xa8;
    }

    public static class ColorGradingEffect {
         public const long Enabled = 0xa0;
         public const long TonemapperPreset = 0xa8;
    }

    public static class DataModel {
         public const long CreatorId = 0x178;
         public const long GameId = 0x180;
         public const long GameLoaded = 0x5d0;
         public const long JobId = 0x110;
         public const long PlaceId = 0x188;
         public const long PlaceVersion = 0x1a4;
         public const long PrimitiveCount = 0x418;
         public const long ScriptContext = 0x440;
         public const long ServerIP = 0x5b8;
         public const long ToRenderView1 = 0x1c0;
         public const long ToRenderView2 = 0x8;
         public const long ToRenderView3 = 0x28;
         public const long Workspace = 0x150;
    }

    public static class DepthOfFieldEffect {
         public const long Enabled = 0xa0;
         public const long FarIntensity = 0xa8;
         public const long FocusDistance = 0xac;
         public const long InFocusRadius = 0xb0;
         public const long NearIntensity = 0xb4;
    }

    public static class DragDetector {
         public const long ActivatedCursorIcon = 0x1b0;
         public const long CursorIcon = 0xb8;
         public const long MaxActivationDistance = 0xd8;
         public const long MaxDragAngle = 0x298;
         public const long MaxDragTranslation = 0x25c;
         public const long MaxForce = 0x29c;
         public const long MaxTorque = 0x2a0;
         public const long MinDragAngle = 0x2a4;
         public const long MinDragTranslation = 0x268;
         public const long ReferenceInstance = 0x1e0;
         public const long Responsiveness = 0x2b0;
    }

    public static class FakeDataModel {
         public const long Pointer = 0x8dc8000;
         public const long RealDataModel = 0x1f8;
    }

    public static class FileMeshData {
         public const long AABBMax = 0x18c;
         public const long AABBMin = 0x180;
         public const long Faces = 0x30;
         public const long FacesEnd = 0x38;
         public const long Vertices = 0x0;
         public const long VerticesEnd = 0x8;
    }

    public static class GuiBase2D {
         public const long AbsolutePosition = 0xfc;
         public const long AbsoluteRotation = 0xd8;
         public const long AbsoluteSize = 0x0;
    }

    public static class GuiObject {
         public const long BackgroundColor3 = 0x530;
         public const long BackgroundTransparency = 0x53c;
         public const long BorderColor3 = 0x53c;
         public const long Image = 0x9a8;
         public const long LayoutOrder = 0x56c;
         public const long Position = 0x500;
         public const long RichText = 0xba0;
         public const long Rotation = 0xd8;
         public const long ScreenGui_Enabled = 0x4b4;
         public const long Size = 0x520;
         public const long Text = 0xe08;
         public const long TextColor3 = 0xeb8;
         public const long Visible = 0x59d;
         public const long ZIndex = 0x594;
    }

    public static class Humanoid {
         public const long AutoJumpEnabled = 0x1d0;
         public const long AutoRotate = 0x1d1;
         public const long AutomaticScalingEnabled = 0x1d2;
         public const long BreakJointsOnDeath = 0xd5;
         public const long CameraOffset = 0x118;
         public const long DisplayDistanceType = 0x17c;
         public const long DisplayName = 0xa8;
         public const long EvaluateStateMachine = 0x1d4;
         public const long FloorMaterial = 0x180;
         public const long Health = 0x18c;
         public const long HealthDisplayDistance = 0x184;
         public const long HealthDisplayType = 0x188;
         public const long HipHeight = 0x190;
         public const long HumanoidRootPart = 0x468;
         public const long HumanoidState = 0x8b0;
         public const long HumanoidStateID = 0x20;
         public const long IsWalking = 0xa2f;
         public const long Jump = 0x1d7;
         public const long JumpHeight = 0x19c;
         public const long JumpPower = 0x1a0;
         public const long MaxHealth = 0x1a4;
         public const long MaxSlopeAngle = 0x1a8;
         public const long MoveDirection = 0x13c;
         public const long MoveToPart = 0x108;
         public const long MoveToPoint = 0x160;
         public const long NameDisplayDistance = 0x1ac;
         public const long NameOcclusion = 0x1b0;
         public const long PlatformStand = 0x1d9;
         public const long RequiresNeck = 0x1da;
         public const long RigType = 0x1bc;
         public const long SeatPart = 0xf8;
         public const long Sit = 0x1da;
         public const long TargetPoint = 0x148;
         public const long UseJumpPower = 0x1dd;
         public const long WalkTimer = 0x3f0;
         public const long Walkspeed = 0x1cc;
         public const long WalkspeedCheck = 0x3a4;
    }

    public static class Instance {
         public const long ChildrenEnd = 0x8;
         public const long ChildrenStart = 0x78;
         public const long ClassBase = 0x1b0;
         public const long ClassDescriptor = 0x18;
         public const long ClassName = 0x8;
         public const long Name = 0x8;
         public const long NameContainer = 0x70;
         public const long Parent = 0x68;
         public const long This = 0x8;
    }

    public static class LRUHolder {
         public const long MemEnforcedLRUCache = 0x20;
    }

    public static class LRUNode {
         public const long AssetID = 0x10;
         public const long CachedItem = 0x40;
         public const long Next = 0x0;
    }

    public static class Lighting {
         public const long Ambient = 0xc0;
         public const long Brightness = 0x108;
         public const long ClockTime = 0xb8;
         public const long ColorShift_Bottom = 0xd8;
         public const long ColorShift_Top = 0xcc;
         public const long EnvironmentDiffuseScale = 0x10c;
         public const long EnvironmentSpecularScale = 0x110;
         public const long ExposureCompensation = 0x114;
         public const long FogColor = 0xe4;
         public const long FogEnd = 0x11c;
         public const long FogStart = 0x120;
         public const long GeographicLatitude = 0x124;
         public const long GlobalShadows = 0x134;
         public const long GradientBottom = 0x180;
         public const long GradientTop = 0x140;
         public const long LightColor = 0x14c;
         public const long LightDirection = 0x158;
         public const long MoonPosition = 0x174;
         public const long OutdoorAmbient = 0xf0;
         public const long Sky = 0x1b8;
         public const long Source = 0x164;
         public const long SunPosition = 0x168;
    }

    public static class LocalScript {
         public const long ByteCode = 0x0;
         public const long GUID = 0xc0;
         public const long Hash = 0x190;
    }

    public static class MaterialColors {
         public const long Asphalt = 0x30;
         public const long Basalt = 0x27;
         public const long Brick = 0xf;
         public const long Cobblestone = 0x33;
         public const long Concrete = 0xc;
         public const long CrackedLava = 0x2d;
         public const long Glacier = 0x1b;
         public const long Grass = 0x6;
         public const long Ground = 0x2a;
         public const long Ice = 0x36;
         public const long LeafyGrass = 0x39;
         public const long Limestone = 0x3f;
         public const long Mud = 0x24;
         public const long Pavement = 0x42;
         public const long Rock = 0x18;
         public const long Salt = 0x3c;
         public const long Sand = 0x12;
         public const long Sandstone = 0x21;
         public const long Slate = 0x9;
         public const long Snow = 0x1e;
         public const long WoodPlanks = 0x15;
    }

    public static class MemEnforcedLRUCache {
         public const long Head = 0x8;
    }

    public static class MeshContentProvider {
         public const long LRUHolder = 0xc8;
    }

    public static class MeshPart {
         public const long MeshId = 0x300;
         public const long Texture = 0x330;
    }

    public static class Misc {
         public const long Adornee = 0xe0;
         public const long AnimationId = 0xb0;
         public const long StringLength = 0x10;
         public const long Value = 0xa8;
    }

    public static class Model {
         public const long PrimaryPart = 0x248;
         public const long Scale = 0x134;
    }

    public static class ModuleScript {
         public const long ByteCode = 0x0;
         public const long GUID = 0xc0;
         public const long Hash = 0x350;
         public const long IsCoreScript = 0x0;
    }

    public static class MouseService {
         public const long InputObject = 0xe0;
         public const long InputObject2 = 0xf0;
         public const long MousePosition = 0xc4;
         public const long SensitivityPointer = 0x0;
    }

    public static class ParticleEmitter {
         public const long Acceleration = 0x1d0;
         public const long Brightness = 0x20c;
         public const long Drag = 0x210;
         public const long Lifetime = 0x1e4;
         public const long LightEmission = 0x228;
         public const long LightInfluence = 0x22c;
         public const long Rate = 0x238;
         public const long RotSpeed = 0x1ec;
         public const long Rotation = 0x1f4;
         public const long Speed = 0x1fc;
         public const long SpreadAngle = 0x204;
         public const long Texture = 0x1b0;
         public const long TimeScale = 0x24c;
         public const long VelocityInheritance = 0x250;
         public const long ZOffset = 0x254;
    }

    public static class Player {
         public const long AccountAge = 0x35c;
         public const long CameraMode = 0x370;
         public const long DisplayName = 0x128;
         public const long HealthDisplayDistance = 0x394;
         public const long LocalPlayer = 0x120;
         public const long LocaleId = 0x108;
         public const long MaxZoomDistance = 0x368;
         public const long MinZoomDistance = 0x36c;
         public const long ModelInstance = 0x298;
         public const long Mouse = 0x1218;
         public const long NameDisplayDistance = 0x3a4;
         public const long Team = 0x2d8;
         public const long TeamColor = 0x3b0;
         public const long UserId = 0xc0;
    }

    public static class PlayerConfigurer {
         public const long Pointer = 0x0;
    }

    public static class PlayerMouse {
         public const long Icon = 0xb8;
         public const long Workspace = 0x140;
    }

    public static class Primitive {
         public const long AssemblyAngularVelocity = 0xec;
         public const long AssemblyLinearVelocity = 0xe0;
         public const long Flags = 0x1be;
         public const long Material = 0x0;
         public const long Owner = 0x218;
         public const long Position = 0xd4;
         public const long Rotation = 0xb0;
         public const long Size = 0x1c4;
         public const long Validate = 0x6;
    }

    public static class PrimitiveFlags {
         public const long Anchored = 0x2;
         public const long CanCollide = 0x8;
         public const long CanQuery = 0x20;
         public const long CanTouch = 0x10;
    }

    public static class ProximityPrompt {
         public const long ActionText = 0xa0;
         public const long Enabled = 0x126;
         public const long GamepadKeyCode = 0x10c;
         public const long HoldDuration = 0x110;
         public const long KeyCode = 0x114;
         public const long MaxActivationDistance = 0x118;
         public const long ObjectText = 0xc0;
         public const long RequiresLineOfSight = 0x127;
    }

    public static class RenderJob {
         public const long FakeDataModel = 0x38;
         public const long RealDataModel = 0x1f0;
         public const long RenderView = 0x1e0;
    }

    public static class RenderView {
         public const long DeviceD3D11 = 0x0;
         public const long LightingValid = 0x0;
         public const long SkyValid = 0x0;
         public const long VisualEngine = 0x0;
    }

    public static class RunService {
         public const long HeartbeatFPS = 0xc8;
         public const long HeartbeatTask = 0xe0;
    }

    public static class Script {
         public const long ByteCode = 0x0;
         public const long GUID = 0xc0;
         public const long Hash = 0x190;
    }

    public static class ScriptContext {
         public const long RequireBypass = 0x0;
    }

    public static class Seat {
         public const long Occupant = 0x208;
    }

    public static class Sky {
         public const long MoonAngularSize = 0x234;
         public const long MoonTextureId = 0xb8;
         public const long SkyboxBk = 0xe8;
         public const long SkyboxDn = 0x118;
         public const long SkyboxFt = 0x148;
         public const long SkyboxLf = 0x178;
         public const long SkyboxOrientation = 0x228;
         public const long SkyboxRt = 0x1a8;
         public const long SkyboxUp = 0x1d8;
         public const long StarCount = 0x238;
         public const long SunAngularSize = 0x22c;
         public const long SunTextureId = 0x208;
    }

    public static class Sound {
         public const long IsPlaying = 0x130;
         public const long Looped = 0x12d;
         public const long PlaybackSpeed = 0x10c;
         public const long RollOffMaxDistance = 0x110;
         public const long RollOffMinDistance = 0x114;
         public const long SoundGroup = 0xd8;
         public const long SoundId = 0xb8;
         public const long Volume = 0x120;
    }

    public static class SpawnLocation {
         public const long AllowTeamChangeOnTouch = 0x3d;
         public const long Enabled = 0x1e1;
         public const long ForcefieldDuration = 0x1d8;
         public const long Neutral = 0x1e2;
         public const long TeamColor = 0x1dc;
    }

    public static class SpecialMesh {
         public const long MeshId = 0xe8;
         public const long Scale = 0xb4;
    }

    public static class StatsItem {
         public const long Value = 0x500;
    }

    public static class SunRaysEffect {
         public const long Enabled = 0xa0;
         public const long Intensity = 0xa8;
         public const long Spread = 0xac;
    }

    public static class SurfaceAppearance {
         public const long AlphaMode = 0x1e0;
         public const long Color = 0x1c8;
         public const long ColorMap = 0xb8;
         public const long EmissiveMaskContent = 0xe8;
         public const long EmissiveStrength = 0x1e4;
         public const long EmissiveTint = 0x1d4;
         public const long MetalnessMap = 0x118;
         public const long NormalMap = 0x148;
         public const long RoughnessMap = 0x178;
    }

    public static class TaskScheduler {
         public const long JobEnd = 0xd0;
         public const long JobName = 0x18;
         public const long JobStart = 0xc8;
         public const long MaxFPS = 0xb0;
         public const long Pointer = 0x8d71348;
    }

    public static class Team {
         public const long BrickColor = 0xa8;
    }

    public static class Terrain {
         public const long GrassLength = 0x1e0;
         public const long MaterialColors = 0x4a8;
         public const long WaterColor = 0x1d0;
         public const long WaterReflectance = 0x1e8;
         public const long WaterTransparency = 0x1ec;
         public const long WaterWaveSize = 0x1f0;
         public const long WaterWaveSpeed = 0x1f4;
    }

    public static class Textures {
         public const long Decal_Texture = 0x1d0;
         public const long Texture_Texture = 0x1d0;
    }

    public static class Tool {
         public const long CanBeDropped = 0x4a8;
         public const long Enabled = 0x4a9;
         public const long Grip = 0x49c;
         public const long ManualActivationOnly = 0x4aa;
         public const long RequiresHandle = 0x4ab;
         public const long TextureId = 0x350;
         public const long Tooltip = 0x458;
    }

    public static class UnionOperation {
         public const long AssetId = 0x300;
    }

    public static class UserInputService {
         public const long WindowInputState = 0x2b0;
    }

    public static class VehicleSeat {
         public const long MaxSpeed = 0x218;
         public const long SteerFloat = 0x21c;
         public const long ThrottleFloat = 0x220;
         public const long Torque = 0x224;
         public const long TurnSpeed = 0x228;
    }

    public static class VisualEngine {
         public const long Dimensions = 0xb10;
         public const long FakeDataModel = 0xaf0;
         public const long Pointer = 0x884c2e0;
         public const long RenderView = 0xc38;
         public const long ViewMatrix = 0x1b0;
    }

    public static class Weld {
         public const long Part0 = 0x108;
         public const long Part1 = 0x118;
    }

    public static class WeldConstraint {
         public const long Part0 = 0xa8;
         public const long Part1 = 0xb8;
    }

    public static class WindowInputState {
         public const long CapsLock = 0x40;
         public const long CurrentTextBox = 0x48;
    }

    public static class Workspace {
         public const long CurrentCamera = 0x4a8;
         public const long DistributedGameTime = 0x4c8;
         public const long ReadOnlyGravity = 0x9c8;
         public const long World = 0x400;
    }

    public static class World {
         public const long AirProperties = 0x238;
         public const long FallenPartsDestroyHeight = 0x214;
         public const long Gravity = 0x220;
         public const long Primitives = 0x2c8;
         public const long worldStepsPerSec = 0x880;
    }

}
