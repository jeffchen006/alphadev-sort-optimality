# n=5 model=out iset=I1 prefix14_class=9660
mov S0, P1
cmp P0, P3
mov S2, P0
cmovg P0, P3
cmovle S2, P3
cmp S0, P2
cmovle P1, P2
cmovg S0, P2
cmp S2, P1
cmovge S1, S2
mov P2, P0
cmovge S2, P1
cmovge P1, S1
cmp S0, P0
