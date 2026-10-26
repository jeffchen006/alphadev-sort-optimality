# n=5 model=out iset=I1 prefix14_class=8690
cmp P3, P0
mov S1, P3
cmovl P3, P0
cmovg S1, P0
mov S0, P1
cmp P2, S0
cmovl S0, P2
cmovle P2, P1
cmp P2, P3
cmovg S2, P2
cmovle S2, P3
cmovle P3, P2
cmp S1, S0
cmovle P2, S1
