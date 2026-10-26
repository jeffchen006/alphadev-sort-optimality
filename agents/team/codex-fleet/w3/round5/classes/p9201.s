# n=5 model=out iset=I1 prefix14_class=9201
mov S1, P0
mov S2, P1
cmp P3, P1
cmovg P1, P3
cmovg P3, S2
cmp P2, S1
mov S0, P3
cmovl P0, P2
cmovge S1, P2
cmp P0, P3
cmovg P3, P0
cmovg P0, S0
cmp S1, P1
cmovle S0, S1
