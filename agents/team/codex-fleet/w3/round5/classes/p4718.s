# n=5 model=out iset=I1 prefix14_class=4718
mov S0, P3
cmp P0, P2
cmovle S1, P0
cmovl P0, P2
cmovle P2, S1
cmp S0, P1
cmovg P3, P1
cmovge P1, S0
mov S0, P1
mov S2, P2
cmp P0, S0
cmovle P1, P0
cmovg S0, P0
cmp P2, P3
