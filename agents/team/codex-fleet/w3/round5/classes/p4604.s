# n=5 model=out iset=I1 prefix14_class=4604
mov S1, P0
cmp P3, P0
cmovg S1, P3
cmovle P0, P3
cmp P2, P1
cmovle S2, P1
cmovle P1, P2
mov P3, S1
cmovl P2, S2
cmp P2, S1
mov S0, P1
cmovl S1, P2
cmovg P3, P2
cmp P0, S0
