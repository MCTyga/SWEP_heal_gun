AddCSLuaFile()

SWEP.Author                     =   "Grüner Mexikaner/MCTyga"
SWEP.Base                       =   "weapon_base"
SWEP.PrintName                  =   "Heal gun"
SWEP.Instructions               =   "Heal player you are looking at with LMB and yourself with RMB"


SWEP.ViewModel                  =   "models/weapons/c_357.mdl"
SWEP.ViewModelFlip              =   false
SWEP.UseHands                   =   true
SWEP.WorldModel                 =   "models/weapons/w_357.mdl"
SWEP.SetHoldType                =   "pistol"

SWEP.Weight                     =   5
SWEP.AutoSwitchTo               =   true
SWEP.AutoSwitchFrom             =   false

SWEP.Slot                       =   1
SWEP.SlotPos                    =   0

SWEP.DrawAmmo                   =   false
SWEP.DrawCrosshair              =   true

SWEP.Spawnable                  =   true 
SWEP.AdminSpawnable             =   true 

SWEP.Primary.ClipSize           =   100
SWEP.Primary.DefaultClip        =   100
SWEP.Primary.Ammo               =   "357"
SWEP.Primary.Automatic          =   true
SWEP.Primary.Recoil             =   0
SWEP.Primary.Damage             =   -20         -- negative damage => heal | edit this value e.g. -100 ist 100 heal per shot
SWEP.Primary.NumShots           =   1
SWEP.Primary.Spread             =   0
SWEP.Primary.Cone               =   0
SWEP.Primary.Delay              =   0.5

SWEP.Secondary.ClipSize         =   100
SWEP.Secondary.DefaultClip      =   100
SWEP.Secondary.Ammo             =   "357"
SWEP.Secondary.Automatic        =   true

SWEP.ShouldDropOnDie            =   false





local ShootSound = Sound("Weapon_357.Single")

function SWEP:Initialize()

    self:SetHoldType("pistol")

end

function SWEP:PrimaryAttack()

    if( not self:CanPrimaryAttack() ) then
    return 
    end
    

    local ply = self:GetOwner()

    ply:LagCompensation( true )
    local Bullet = {}
    Bullet.Num            =       self.Primary.NumShots
    Bullet.Src            =       ply:GetShootPos()
    Bullet.Dir            =       ply:GetAimVector()
    Bullet.Spread         =       Vector( self.Primary.Spread, self.Primary.Spreaad, 0 )
    Bullet.Tracer         =       0
    Bullet.Damage         =       self.Primary.Damage
    Bullet.AmmoType       =       self.Primary.Ammo

    self:FireBullets( Bullet )
    self:ShootEffects()
    
    self:EmitSound( ShootSound )
    self.BaseClass.ShootEffects( self )
    self:TakePrimaryAmmo( 1 )
    self:SetNextPrimaryFire( CurTime() + self.Primary.Delay)

    


    ply:LagCompensation( false )
end

function SWEP:SecondaryAttack()
    return false
end
