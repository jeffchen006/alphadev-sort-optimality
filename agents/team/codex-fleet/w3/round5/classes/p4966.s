# n=5 model=out iset=I1 prefix14_class=4966
mov S0, P0
cmp S0, P3
cmovle P0, P3
cmovg S0, P3
mov S1, P1
cmp P1, P2
cmovg P1, P2
cmovle S1, P2
cmovle P2, P1
cmp S0, P1
cmovl P2, S0
cmovl S0, P1
cmp P0, S1
cmovg P1, S0
