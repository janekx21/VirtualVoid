using System;
using System.Globalization;
using System.Linq;
using System.Reactive.Linq;
using System.Reactive.Subjects;
using System.Security.Claims;
using System.Threading;
using System.Threading.Tasks;
using GraphQL.Resolvers;
using GraphQL.Server.Transports.Subscriptions.Abstractions;
using GraphQL.Subscription;
using GraphQL.Types;
using VirtualVoid.Model;

namespace VirtualVoid {
    public sealed class SubscriptionType : ObjectGraphType<object> {
        public ISubject<DateTime> o = new ReplaySubject<DateTime>();

        public SubscriptionType() {
            o.OnNext(DateTime.Now);

            FieldSubscribe<StringGraphType>("time",
                resolve: context => context.Source as string,
                subscribe: context => {
                    Task.Run(() => {
                        while (!context.CancellationToken.IsCancellationRequested) {
                            Thread.Sleep(1000);
                            o.OnNext(DateTime.Now);
                        }
                    });
                    return o.Select(i => i.ToString());
                });
        }
    }
}
