﻿namespace Echoes.Tests.WinRT;

interface

uses
  System,
  System.Collections.Generic,
  System.IO,
  System.Linq,
  System.Reflection,
  Windows.ApplicationModel,
  Windows.ApplicationModel.Activation,
  Windows.Foundation,
  Windows.Foundation.Collections,
  Windows.UI.Xaml,
  Windows.UI.Xaml.Controls,
  Windows.UI.Xaml.Controls.Primitives,
  Windows.UI.Xaml.Data,
  Windows.UI.Xaml.Input,
  Windows.UI.Xaml.Media,
  Windows.UI.Xaml.Navigation,
  RemObjects.Elements.EUnit;

// The Blank Application template is documented at http://go.microsoft.com/fwlink/?LinkId=234227

/// <summary>
/// Provides application-specific behavior to supplement the default Application class.
/// </summary>
type
  App = partial class(Application)
  private
    /// <summary>
    /// Invoked when application execution is being suspended.  Application state is saved
    /// without knowing whether the application will be terminated or resumed with the contents
    /// of memory still intact.
    /// </summary>
    /// <param name="sender">The source of the suspend request.</param>
    /// <param name="e">Details about the suspend request.</param>
    method OnSuspending(sender: System.Object; e: SuspendingEventArgs);
    method Filter(Item: ITest);
  protected
    /// <summary>
    /// Invoked when the application is launched normally by the end user.  Other entry points
    /// will be used when the application is launched to open a specific file, to display
    /// search results, and so forth.
    /// </summary>
    /// <param name="args">Details about the launch request and process.</param>
    method OnLaunched(args: LaunchActivatedEventArgs); override;
  public
    /// <summary>
    /// Initializes the singleton application object.  This is the first line of authored code
    /// executed, and as such is the logical equivalent of main() or WinMain().
    /// </summary>
    constructor ;
  end;


implementation

constructor App;
begin
  self.InitializeComponent();
  self.Suspending += OnSuspending;
end;

method App.OnLaunched(args: LaunchActivatedEventArgs);
begin
  // Do not repeat app initialization when already running, just ensure that
  // the window is active
  if args.PreviousExecutionState = ApplicationExecutionState.Running then begin
    Window.Current.Activate();
    exit
  end;

  if args.PreviousExecutionState = ApplicationExecutionState.Terminated then begin
     //TODO: Load state from previously suspended application
  end;

  try
    var TestItems := Discovery.Discover(self.GetType.GetTypeInfo.Assembly);
    Filter(TestItems);

    var TestResults := Runner.Run(TestItems, nil);
    var Writer := new ConsoleWriter(TestResults);
    Writer.WriteFull;
    Writer.WriteLine("===================================================");
    Writer.WriteSummary;
    System.Diagnostics.Debug.WriteLine(Writer.Output);
  except
    on E: Exception do
      System.Diagnostics.Debug.WriteLine("Unable to perform test: " + E.Message); 
  end;

  Application.Current.Exit;

  // Create a Frame to act navigation context and navigate to the first page
  var rootFrame := new Frame();
  if not rootFrame.Navigate(typeOf(MainPage)) then begin
    raise new Exception('Failed to create initial page')
  end;

  // Place the frame in the current Window and ensure that it is active
  Window.Current.Content := rootFrame;
  Window.Current.Activate()
end;

method App.OnSuspending(sender: System.Object; e: SuspendingEventArgs);
begin
  var deferral := e.SuspendingOperation.GetDeferral();
  //TODO: Save application state and stop any background activity
  deferral.Complete()
end;

method App.Filter(Item: ITest);
begin
  if (Item.Kind = TestKind.Test) and (Item.Name.StartsWith("_")) then
    Item.Skip := true;

  for child in Item.Childrens do
    Filter(child);
end;

end.
