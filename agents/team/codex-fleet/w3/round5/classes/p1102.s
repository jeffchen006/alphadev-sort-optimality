# n=5 model=out iset=I1 prefix14_class=1102
mov S0, P0
cmp P0, P2
cmovl P0, P2
cmovle P2, S0
cmp P1, P3
mov S0, P1
mov S1, P0
cmovle S0, P3
cmovg P1, P3
cmp P0, S0
cmovle S1, S0
cmovle S0, P0
cmp P2, P1
cmovg P0, P2
