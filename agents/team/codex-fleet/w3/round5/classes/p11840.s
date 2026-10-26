# n=5 model=out iset=I1 prefix14_class=11840
cmp P0, P1
cmovle S1, P0
cmovl P0, P1
cmovle P1, S1
mov S0, P0
cmp P3, P2
cmovle S1, P3
cmovle P3, P2
cmovle P2, S1
cmp P3, S0
cmovle S0, P3
mov S2, P2
cmovg P0, P3
cmp P1, S2
