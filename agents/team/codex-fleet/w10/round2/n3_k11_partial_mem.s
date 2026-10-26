# n=3 model=mem iset=I1 source=w10_partial_sat_translation
mov S0, P0
mov S1, P1
mov S2, P2
cmp S0, S1
cmovle S3, S0
cmovl S0, S1
mov S4, S2
cmovle S1, S3
cmp S2, S1
cmovge S4, S1
mov P0, S4
cmovge S1, S2
cmp S0, S2
cmovg S2, S0
mov P2, S2
cmovge S0, S1
mov P1, S0
