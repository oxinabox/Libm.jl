using Base.Test
using Libm: highword, lowword, combinewords

const fuzztest = true

@testset "Word Splitting" begin
	@test highword(0.0) == 0x0000_0000
	@test lowword(0.0) == 0x0000_0000
	@test combinewords(0x0000_0000, 0x0000_0000) == 0.0

	@test highword(2.0) == 0x4000_0000
	@test lowword(2.0) == 0x0000_0000
	@test combinewords(0x4000_0000, 0x0000_0000) == 2.0

	@test highword(-2.0) == 0xc000_0000
	@test lowword(-2.0) == 0x0000_0000
	@test combinewords(0xc000_0000, 0x0000_0000) == -2.0

	@test highword(NaN) == 0x7ff8_0000
	@test lowword(NaN) == 0x0000_0000
	@test isnan(combinewords(0x7ff8_0000, 0x0000_0000))

	@test highword(1.3) == 0x3ff4_cccc
	@test lowword(1.3) == 0xcccc_cccd
	@test combinewords(0x3ff4_cccc, 0xcccc_cccd) == 1.3


	if fuzztest
		srand(1)
		for testround in 1:1000
			x = rand(Float64)
			@test combinewords(highword(x), lowword(x)) == x
		end
	end

end
