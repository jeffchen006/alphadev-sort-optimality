# n=5 model=out iset=I1 prefix14_class=8982
mov S0, P1
cmp P0, S0
cmovg P1, P0
cmovge P0, S0
cmovl S0, P0
cmp P2, P3
mov S1, P2
cmovle S1, P3
cmovg P2, P3
cmp P1, S1
cmovle P3, S1
cmovl S1, P1
cmovl P1, P3
cmp S0, P2
