# n=5 model=out iset=I1 prefix14_class=4518
mov S2, P3
mov S0, P2
cmp P2, P0
cmovge P2, P0
cmovle S0, P0
cmp S2, P1
cmovge P3, P1
cmovg P1, S2
mov S2, P1
cmp S2, S0
cmovge S2, S0
cmovge S0, P1
cmp P2, P3
cmovg P0, P3
