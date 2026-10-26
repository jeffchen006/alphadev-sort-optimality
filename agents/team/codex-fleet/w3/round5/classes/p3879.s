# n=5 model=out iset=I1 prefix14_class=3879
mov S1, P0
cmp P0, P3
cmovge P0, P3
mov S0, P2
cmovg P3, S1
cmp S0, P1
mov S2, P0
cmovle S0, P1
cmovle P1, P2
cmp S2, P1
cmovl S2, P1
cmovl P1, P0
cmp P3, S0
cmovg P1, P3
