# n=5 model=out iset=I1 prefix14_class=8163
cmp P3, P0
mov S2, P3
cmovle S2, P0
cmovl P0, P3
cmp P2, P1
cmovg S1, P2
cmovg P2, P1
cmovg P1, S1
cmp P0, P2
cmovle S0, P0
cmovge S0, P2
cmovg P2, P0
cmp S2, P1
mov P0, P2
