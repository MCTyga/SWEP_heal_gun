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

SWEP.DrawAmmo                   =   true
SWEP.DrawCrosshair              =   true

SWEP.Spawnable                  =   true 
SWEP.AdminSpawnable             =   true 

SWEP.Primary.ClipSize           =   100
SWEP.Primary.DefaultClip        =   100
SWEP.Primary.Ammo               =   "357"
SWEP.Primary.Automatic          =   true
SWEP.Primary.Recoil             =   0
SWEP.HealAmount 		= 20                            -- Maximum heal amount per use´
SWEP.MaxHealth 			= 200				-- this value is tha maximum health that can be gained by using the SWEP
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

	if ( CLIENT ) then return end

	if ( self.Owner:IsPlayer() ) then
		self.Owner:LagCompensation( true )
	end

	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 256,
		filter = self.Owner
	} )

	if ( self.Owner:IsPlayer() ) then
		self.Owner:LagCompensation( false )
	end

	local ent = tr.Entity

	local need = self.HealAmount
	if ( IsValid( ent ) ) then need = math.min( SWEP.MaxHealth - ent:Health(), self.HealAmount ) end

	if ( IsValid( ent ) && self:Clip1() >= need && ( ent:IsPlayer() or ent:IsNPC() ) && ent:Health() < SWEP.MaxHealth ) then

		self:TakePrimaryAmmo( need )
        ent:SetHealth( ent:Health() + SWEP.HealAmount )
		self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

		self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() + 0.5 )
		self.Owner:SetAnimation( PLAYER_ATTACK1 )

		-- Even though the viewmodel has looping IDLE anim at all times, we need this to make fire animation work in multiplayer
		timer.Create( "weapon_idle" .. self:EntIndex(), self:SequenceDuration(), 1, function() if ( IsValid( self ) ) then self:SendWeaponAnim( ACT_VM_IDLE ) end end )


	end

end

function SWEP:SecondaryAttack()

	if ( CLIENT ) then return end

	local ent = self.Owner

	local need = self.HealAmount
	if ( IsValid( ent ) ) then need = math.min( SWEP.MaxHealth - ent:Health(), self.HealAmount ) end

	if ( IsValid( ent ) && self:Clip1() >= need && ent:Health() < SWEP.MaxHealth ) then

		self:TakePrimaryAmmo( need )


		self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

		self:SetNextSecondaryFire( CurTime() + self:SequenceDuration() + 0.5 )
		self.Owner:SetAnimation( PLAYER_ATTACK1 )

		timer.Create( "weapon_idle" .. self:EntIndex(), self:SequenceDuration(), 1, function() if ( IsValid( self ) ) then self:SendWeaponAnim( ACT_VM_IDLE ) end end )

	end

end
