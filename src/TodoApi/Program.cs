

using TodoApi;
using TodoApi.Apis;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddCors(options => options.AddPolicy(name: "AllowAll", builder => { builder.WithOrigins("*", "*"); }));
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddLogging(logging =>
{
    var appInsightsConnectionString = AppConfig.GetAppInsightsConnStrFromEnv();
    if (!string.IsNullOrEmpty(appInsightsConnectionString))
    {
        logging.AddApplicationInsights(telemetryConfig =>
        {
            telemetryConfig.ConnectionString = appInsightsConnectionString;
        },
        aiLoggingOptions =>
        {
            aiLoggingOptions.TrackExceptionsAsExceptionTelemetry = true;
        });
    }
    logging.AddConfiguration(builder.Configuration.GetSection("Logging"));
    logging.AddConsole();
    logging.AddDebug();
});

var app = builder.Build();
app.UseSwagger();
app.UseSwaggerUI();
app.UseHttpsRedirection();

ToDoApiConfig.Configure(app);
SoftwareVersion.Configure(app);

app.Run();

