# n=5 model=out iset=I1 prefix14_class=10522
cmp P3, P2
mov S1, P0
cmovle S2, P3
cmovg S2, P2
cmovle P3, P2
cmp P1, P0
cmovg S1, P1
cmovg P1, P0
cmp P3, S1
cmovle S0, S1
cmovl S1, P3
cmovle P3, S0
mov P0, P1
cmp P1, S2
