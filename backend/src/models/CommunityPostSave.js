const { DataTypes} = require("sequelize")
const sequelize = require("../config/database")

const User = require("./User")
const communityPost = require("./CommunityPost")

const CommunityPostSave = sequelize.define(
    "CommunityPostSave", 
    {
        userId: {
            type: DataTypes.INTEGER,
            allowNull: false,
        },
        postId: {
            type: DataTypes.INTEGER,
            allowNull: false,
        },
    },
    {
        indexes: [
            {
                unique: true,
                fields: ["userId", "postId"],
            },
        ],
    }
);

CommunityPostSave.belongsTo(User, { foreignKey: "userId" });
User.hasMany(CommunityPostSave, { foreignKey: "userId" });

CommunityPostSave.belongsTo(communityPost, { foreignKey: "postId" });
communityPost.hasMany(CommunityPostSave, { foreignKey: "postId" });

module.exports = CommunityPostSave;