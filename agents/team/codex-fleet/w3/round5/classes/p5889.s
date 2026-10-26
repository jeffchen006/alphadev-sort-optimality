# n=5 model=out iset=I1 prefix14_class=5889
mov S2, P0
cmp P1, P0
cmovg P0, P1
mov S1, P2
cmovge P1, S2
cmp P3, P2
cmovl S1, P3
cmovl P3, P2
cmp P3, P0
cmovg S0, P0
cmovg P0, P3
cmovle S0, P3
cmp P1, S1
cmovle P3, P1
