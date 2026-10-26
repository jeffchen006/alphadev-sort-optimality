# n=5 model=out iset=I1 prefix14_class=11627
cmp P2, P1
cmovge S0, P2
cmovle S0, P1
cmovg P2, P1
cmp P0, P3
cmovge S1, P0
cmovg P0, P3
cmovg P3, S1
cmp S0, P3
mov P1, S0
cmovge P1, P3
cmovle S0, P3
mov S0, P0
cmp S0, P2
