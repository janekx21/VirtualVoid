using System.Collections.Generic;
using EventSourceDemo;
using GraphQL.Types;
using VirtualVoid.Model;

namespace VirtualVoid {
    public sealed class IssueType : ObjectGraphType<Types.Issue> {
        public IssueType() {
            Field(x => x.id);
            Field(x => x.title);
            Field(x => x.description);
            Field(x => x.state);
        }
    }
}
