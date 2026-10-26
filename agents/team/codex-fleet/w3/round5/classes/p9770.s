# n=5 model=out iset=I1 prefix14_class=9770
mov S0, P2
cmp P1, P2
mov S1, P0
cmovl S0, P1
cmovle P1, P2
cmp P3, S1
cmovle S1, P3
cmovl P3, P0
cmp P1, P3
cmovg P2, P3
cmovge P3, P1
cmovg P1, P2
cmp S0, S1
cmovl P0, S0
