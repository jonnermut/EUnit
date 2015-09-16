﻿namespace Echoes.Tests.WP8;

interface

uses
  System,
  System.Diagnostics,
  System.Resources,
  System.Windows,
  System.Windows.Markup,
  System.Windows.Navigation,
  Microsoft.Phone.Controls,
  Microsoft.Phone.Shell,
  RemObjects.Elements.EUnit,
  Echoes.Tests.WP8.Resources;

type
  App = public partial class(Application)

  public
    /// <summary>
    /// Provides easy access to the root frame of the Phone Application.
    /// </summary>
    /// <returns>The root frame of the Phone Application.</returns>
    class property RootFrame: PhoneApplicationFrame;

    /// <summary>
    /// Constructor for the Application object.
    /// </summary>
    constructor ;

  private
    // Code to execute when the application is launching (eg, from Start)
    // This code will not execute when the application is reactivated
    method Application_Launching(sender: System.Object; e: LaunchingEventArgs);

    // Code to execute when the application is activated (brought to foreground)
    // This code will not execute when the application is first launched
    method Application_Activated(sender: System.Object; e: ActivatedEventArgs);

    // Code to execute when the application is deactivated (sent to background)
    // This code will not execute when the application is closing
    method Application_Deactivated(sender: System.Object; e: DeactivatedEventArgs);

    // Code to execute when the application is closing (eg, user hit Back)
    // This code will not execute when the application is deactivated
    method Application_Closing(sender: System.Object; e: ClosingEventArgs);

    // Code to execute if a navigation fails
    method RootFrame_NavigationFailed(sender: System.Object; e: NavigationFailedEventArgs);

    // Code to execute on Unhandled Exceptions
    method Application_UnhandledException(sender: System.Object; e: ApplicationUnhandledExceptionEventArgs);

    method Filter(Item: ITest);

{$region Phone application initialization}

    // Avoid double-initialization
    var phoneApplicationInitialized: System.Boolean := false;

    // Do not add any additional code to this method
    method InitializePhoneApplication;

    // Do not add any additional code to this method
    method CompleteInitializePhoneApplication(sender: System.Object; e: NavigationEventArgs);
    method CheckForResetNavigation(sender: System.Object; e: NavigationEventArgs);
    method ClearBackStackAfterReset(sender: System.Object; e: NavigationEventArgs);

{$endregion}

    // Initialize the app's font and flow direction as defined in its localized resource strings.
    //
    // To ensure that the font of your application is aligned with its supported languages and that the
    // FlowDirection for each of those languages follows its traditional direction, ResourceLanguage
    // and ResourceFlowDirection should be initialized in each resx file to match these values with that
    // file's culture. For example:
    //
    // AppResources.es-ES.resx
    //    ResourceLanguage's value should be "es-ES"
    //    ResourceFlowDirection's value should be "LeftToRight"
    //
    // AppResources.ar-SA.resx
    //     ResourceLanguage's value should be "ar-SA"
    //     ResourceFlowDirection's value should be "RightToLeft"
    //
    // For more info on localizing Windows Phone apps see http://go.microsoft.com/fwlink/?LinkId=262072.
    //
    method InitializeLanguage;
  end;

implementation

constructor App;
begin
  // Global handler for uncaught exceptions.
  UnhandledException += Application_UnhandledException;

  // Standard XAML initialization
  InitializeComponent();

  // Phone-specific initialization
  InitializePhoneApplication();

  // Language display initialization
  InitializeLanguage();

  // Show graphics profiling information while debugging.
  if Debugger.IsAttached then begin
    // Display the current frame rate counters.
    Application.Current.Host.Settings.EnableFrameRateCounter := true;

    // Show the areas of the app that are being redrawn in each frame.
    //Application.Current.Host.Settings.EnableRedrawRegions = true;

    // Enable non-production analysis visualization mode,
    // which shows areas of a page that are handed off to GPU with a colored overlay.
    //Application.Current.Host.Settings.EnableCacheVisualization = true;

    // Prevent the screen from turning off while under the debugger by disabling
    // the application's idle detection.
    // Caution:- Use this under debug mode only. Application that disables user idle detection will continue to run
    // and consume battery power when the user is not using the phone.
    PhoneApplicationService.Current.UserIdleDetectionMode := IdleDetectionMode.Disabled
  end;

  try
    var TestItems := Discovery.FromAppDomain(AppDomain.CurrentDomain);
    Filter(TestItems);

    var TestResults := Runner.Run(TestItems, nil);
    var Writer := new ConsoleWriter(TestResults);
    Writer.WriteFull;
    Writer.WriteLine("===================================================");
    Writer.WriteSummary;
    System.Diagnostics.Debug.WriteLine(Writer.Output);
  except
    on Ex: Exception do
      System.Diagnostics.Debug.WriteLine("Unable to perform test: " + Ex.Message); 
  end;

  Application.Current.Terminate;
end;

method App.Application_Launching(sender: System.Object; e: LaunchingEventArgs);
begin
end;

method App.Filter(Item: ITest);
begin
  if (Item.Kind = TestKind.Test) and (Item.Name.StartsWith("_")) then
    Item.Skip := true;

  for child in Item.Childrens do
    Filter(child);
end;

method App.Application_Activated(sender: System.Object; e: ActivatedEventArgs);
begin

end;

method App.Application_Deactivated(sender: System.Object; e: DeactivatedEventArgs);
begin
end;

method App.Application_Closing(sender: System.Object; e: ClosingEventArgs);
begin
end;

method App.RootFrame_NavigationFailed(sender: System.Object; e: NavigationFailedEventArgs);
begin
  if Debugger.IsAttached then begin
    // A navigation has failed; break into the debugger
    Debugger.Break()
  end
end;

method App.Application_UnhandledException(sender: System.Object; e: ApplicationUnhandledExceptionEventArgs);
begin
  if Debugger.IsAttached then begin
    // An unhandled exception has occurred; break into the debugger
    Debugger.Break()
  end
end;

method App.InitializePhoneApplication;
begin
  if phoneApplicationInitialized then    exit;

  // Create the frame but don't set it as RootVisual yet; this allows the splash
  // screen to remain active until the application is ready to render.
  RootFrame := new PhoneApplicationFrame();
  RootFrame.Navigated += CompleteInitializePhoneApplication;

  // Handle navigation failures
  RootFrame.NavigationFailed += RootFrame_NavigationFailed;

  // Handle reset requests for clearing the backstack
  RootFrame.Navigated += CheckForResetNavigation;

  // Ensure we don't initialize again
  phoneApplicationInitialized := true
end;

method App.CompleteInitializePhoneApplication(sender: System.Object; e: NavigationEventArgs);
begin
  // Set the root visual to allow the application to render
  if RootVisual <> RootFrame then    RootVisual := RootFrame;

  // Remove this handler since it is no longer needed
  RootFrame.Navigated -= CompleteInitializePhoneApplication
end;

method App.CheckForResetNavigation(sender: System.Object; e: NavigationEventArgs);
begin
  // If the app has received a 'reset' navigation, then we need to check
  // on the next navigation to see if the page stack should be reset
  if e.NavigationMode = NavigationMode.Reset then    RootFrame.Navigated += ClearBackStackAfterReset
end;

method App.ClearBackStackAfterReset(sender: System.Object; e: NavigationEventArgs);
begin
  // Unregister the event so it doesn't get called again
  RootFrame.Navigated -= ClearBackStackAfterReset;

  // Only clear the stack for 'new' (forward) and 'refresh' navigations
  if (e.NavigationMode <> NavigationMode.New) and (e.NavigationMode <> NavigationMode.Refresh) then    exit;

  // For UI consistency, clear the entire page stack
  while RootFrame.RemoveBackEntry() <> nil do begin
    // do nothing
  end

end;

method App.InitializeLanguage;
begin
  try
    // Set the font to match the display language defined by the
    // ResourceLanguage resource string for each supported language.
    //
    // Fall back to the font of the neutral language if the Display
    // language of the phone is not supported.
    //
    // If a compiler error is hit then ResourceLanguage is missing from
    // the resource file.
    RootFrame.Language := XmlLanguage.GetLanguage(AppResources.ResourceLanguage);

    // Set the FlowDirection of all elements under the root frame based
    // on the ResourceFlowDirection resource string for each
    // supported language.
    //
    // If a compiler error is hit then ResourceFlowDirection is missing from
    // the resource file.
    var flow: FlowDirection := FlowDirection(&Enum.Parse(typeOf(FlowDirection), AppResources.ResourceFlowDirection));
    RootFrame.FlowDirection := flow
  
  except begin
    // If an exception is caught here it is most likely due to either
    // ResourceLangauge not being correctly set to a supported language
    // code or ResourceFlowDirection is set to a value other than LeftToRight
    // or RightToLeft.
      if Debugger.IsAttached then begin
        Debugger.Break()
      end;

      raise 
    end;
  end
end;

end.