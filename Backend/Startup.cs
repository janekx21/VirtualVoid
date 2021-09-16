using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using EventSourceDemo;
using GraphQL;
using GraphQL.Server;
using GraphQL.Server.Ui.Voyager;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.OpenApi.Models;

namespace VirtualVoid {
    public class Startup {
        public Startup(IConfiguration configuration) {
            this.configuration = configuration;
        }

        public IConfiguration configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services) {
            // Add GraphQL services and configure options
            services
                // .AddSingleton<IChat, Chat>()
                .AddSingleton<IssueSchema>()
                .AddGraphQL((options, provider) => {
                    options.EnableMetrics = true; // Environment.IsDevelopment();
                    var logger = provider.GetRequiredService<ILogger<Startup>>();
                    options.UnhandledExceptionDelegate = ctx =>
                        logger.LogError("{Error} occurred", ctx.OriginalException.Message);
                })
                // Add required services for GraphQL request/response de/serialization
                .AddSystemTextJson() // For .NET Core 3+
                // .AddNewtonsoftJson() // For everything else
                .AddErrorInfoProvider(opt => opt.ExposeExceptionStackTrace = true) // Environment.IsDevelopment())
                .AddWebSockets() // Add required services for web socket support
                .AddDataLoader() // Add required services for DataLoader support
                .AddGraphTypes(
                    typeof(IssueSchema)); // Add all IGraphType implementors in assembly which ChatSchema exists

            var context = new Context();
            services.AddSingleton(context);

            services.AddSingleton<IDocumentExecuter, SubscriptionDocumentExecuter>();
            // TODO
            // context.restoreDomain();
            services.AddCors(options =>
                options.AddPolicy("DefaultPolicy",
                    builder => builder.AllowAnyHeader().AllowAnyMethod().AllowAnyOrigin()));
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env) {
            app.UseCors("DefaultPolicy");
            // app.UseRouting();

            // this is required for websockets support
            app.UseWebSockets();

            // use websocket middleware for ChatSchema at default path /graphql
            app.UseGraphQLWebSockets<IssueSchema>();

            // use HTTP middleware for ChatSchema at default path /graphql
            app.UseGraphQL<IssueSchema>();

            if (env.IsDevelopment()) {
                app.UseDeveloperExceptionPage();
                // use GraphQL Playground middleware at default path /ui/playground with default options
                app.UseGraphQLPlayground();

                // use Voyager middleware at default path /ui/voyager with default options
                app.UseGraphQLVoyager();
            }
        }
    }
}
