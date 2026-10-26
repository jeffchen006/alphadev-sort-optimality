# n=5 model=out iset=I1 prefix14_class=7666
mov S0, P0
cmp P1, S0
mov S1, P2
cmovl P0, P1
cmovl P1, S0
cmp P3, S1
cmovge P2, P3
mov S0, P2
cmovg P3, S1
cmp P0, P3
cmovle S1, P0
cmovl P0, P3
cmovle P3, S1
cmp P2, P1
