using GraphQL.Types;

namespace Backend {
    public sealed class IssueType : ObjectGraphType<MyTypes.Issue> {
        public IssueType() {
            Field(x => x.id);
            Field(x => x.title);
            Field(x => x.description);
            Field(x => x.children);
        }
    }
}
