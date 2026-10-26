# n=5 model=out iset=I1 prefix14_class=13341
cmp P3, P1
mov S0, P3
cmovg P3, P1
mov S1, P3
cmovg P1, S0
cmp P0, P2
cmovle S0, P0
cmovl P0, P2
cmovle P2, S0
cmp P2, S1
cmovg P3, P2
cmovle S1, P2
cmp P1, P0
cmovle S1, P1
