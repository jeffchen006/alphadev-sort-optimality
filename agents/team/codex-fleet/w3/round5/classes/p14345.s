# n=5 model=out iset=I1 prefix14_class=14345
cmp P0, P1
mov S2, P0
cmovle P0, P1
cmovl P1, S2
cmp P3, P2
cmovle S1, P3
cmovle P3, P2
cmovl P2, S1
cmp P2, P1
cmovle S0, P2
cmovg S0, P1
cmovg P1, P2
mov P2, P3
cmp P0, P2
