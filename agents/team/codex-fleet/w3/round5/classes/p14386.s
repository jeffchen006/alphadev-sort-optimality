# n=5 model=out iset=I1 prefix14_class=14386
cmp P3, P1
cmovle S2, P1
cmovl P1, P3
mov S1, P2
cmovl P3, S2
cmp P2, P0
mov S0, P1
cmovle P2, P0
cmovg S1, P0
cmp P1, S1
cmovg S0, S1
mov S0, P2
cmovle P1, S1
cmp P3, P2
