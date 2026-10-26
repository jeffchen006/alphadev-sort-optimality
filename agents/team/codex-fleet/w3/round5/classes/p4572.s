# n=5 model=out iset=I1 prefix14_class=4572
mov S2, P1
mov S0, P3
cmp S2, P2
cmovge S2, P2
cmovge P2, P1
cmp S0, P0
cmovg P3, P0
cmovle S0, P0
mov P1, S0
cmp P2, P1
cmovl P1, P2
cmovg S0, P2
mov S1, P1
cmp P3, S2
