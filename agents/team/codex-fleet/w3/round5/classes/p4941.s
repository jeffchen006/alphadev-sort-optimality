# n=5 model=out iset=I1 prefix14_class=4941
cmp P3, P2
cmovle S1, P2
cmovge S1, P3
mov S0, P0
cmovg P3, P2
cmp S0, P1
cmovl P0, P1
mov P2, P3
cmovl P1, S0
cmp P3, P1
cmovg P3, P1
cmovge P1, P2
cmp S1, P0
cmovle S0, P0
