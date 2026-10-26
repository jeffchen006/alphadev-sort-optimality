# n=5 model=out iset=I1 prefix14_class=4515
cmp P1, P0
mov S0, P1
mov S1, P3
cmovg P1, P0
cmovle S0, P0
cmp S1, P2
cmovge P3, P2
cmovg P2, S1
cmovle S1, P2
cmp P2, S0
cmovg P2, S0
cmovge S0, S1
cmp P1, P3
cmovl P0, P1
