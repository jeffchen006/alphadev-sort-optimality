# n=5 model=out iset=I1 prefix14_class=13927
cmp P0, P3
mov S2, P0
cmovle S2, P3
cmovl P3, P0
mov S1, S2
cmp P2, P1
cmovge S0, P1
cmovge P1, P2
cmovg P2, S0
cmp S2, P1
cmovge S2, P1
cmovle S1, P1
mov P1, P2
cmp P3, P1
