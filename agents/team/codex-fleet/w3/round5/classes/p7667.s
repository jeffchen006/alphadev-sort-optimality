# n=5 model=out iset=I1 prefix14_class=7667
mov S0, P0
cmp P3, S0
mov S1, P2
cmovl P0, P3
cmovl P3, S0
cmp P1, S1
cmovge P2, P1
mov S0, P2
cmovg P1, S1
cmp P0, P1
cmovle S1, P0
cmovl P0, P1
cmovle P1, S1
cmp P2, P3
