# n=5 model=out iset=I1 prefix14_class=13001
cmp P2, P0
cmovge S2, P0
cmovle S2, P2
mov S0, P1
cmovge P0, P2
cmp P3, P1
cmovle S0, P3
cmovge P1, P3
cmp S2, S0
mov S1, P0
cmovge P2, S0
cmovg S0, S2
cmovg S2, P2
cmp P1, S1
