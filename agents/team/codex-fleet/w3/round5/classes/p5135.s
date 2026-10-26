# n=5 model=out iset=I1 prefix14_class=5135
cmp P3, P0
cmovg S0, P3
cmovle S0, P0
mov S1, P1
cmovle P0, P3
cmp P2, S1
cmovle P1, P2
cmovl P2, S1
mov S1, P1
cmp P0, S1
cmovg P1, P0
cmovl S1, P0
cmp P2, S0
cmovle P3, P2
