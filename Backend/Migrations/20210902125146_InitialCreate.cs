using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace VirtualVoid.Migrations
{
    public partial class InitialCreate : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "boards",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "TEXT", nullable: false),
                    name = table.Column<string>(type: "TEXT", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_boards", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "commits",
                columns: table => new
                {
                    order = table.Column<int>(type: "INTEGER", nullable: false)
                        .Annotation("Sqlite:Autoincrement", true),
                    type = table.Column<string>(type: "TEXT", nullable: false),
                    className = table.Column<string>(type: "TEXT", nullable: false),
                    objectId = table.Column<Guid>(type: "TEXT", nullable: false),
                    payload = table.Column<string>(type: "TEXT", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_commits", x => x.order);
                });

            migrationBuilder.CreateTable(
                name: "states",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "TEXT", nullable: false),
                    name = table.Column<string>(type: "TEXT", nullable: false),
                    Boardid = table.Column<Guid>(type: "TEXT", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_states", x => x.id);
                    table.ForeignKey(
                        name: "FK_states_boards_Boardid",
                        column: x => x.Boardid,
                        principalTable: "boards",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "issues",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "TEXT", nullable: false),
                    title = table.Column<string>(type: "TEXT", nullable: false),
                    description = table.Column<string>(type: "TEXT", nullable: false),
                    stateid = table.Column<Guid>(type: "TEXT", nullable: true),
                    Boardid = table.Column<Guid>(type: "TEXT", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_issues", x => x.id);
                    table.ForeignKey(
                        name: "FK_issues_boards_Boardid",
                        column: x => x.Boardid,
                        principalTable: "boards",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_issues_states_stateid",
                        column: x => x.stateid,
                        principalTable: "states",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_issues_Boardid",
                table: "issues",
                column: "Boardid");

            migrationBuilder.CreateIndex(
                name: "IX_issues_stateid",
                table: "issues",
                column: "stateid");

            migrationBuilder.CreateIndex(
                name: "IX_states_Boardid",
                table: "states",
                column: "Boardid");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "commits");

            migrationBuilder.DropTable(
                name: "issues");

            migrationBuilder.DropTable(
                name: "states");

            migrationBuilder.DropTable(
                name: "boards");
        }
    }
}
