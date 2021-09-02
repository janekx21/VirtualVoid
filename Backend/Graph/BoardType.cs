using GraphQL.Types;
using VirtualVoid.Model;

namespace VirtualVoid {
    public sealed class BoardType : ObjectGraphType<Types.Board> {
        public BoardType() {
            Field(o => o.id);
            Field(o => o.name);
            Field(o => o.issues);
            Field(o => o.states);
        }
    }
}
