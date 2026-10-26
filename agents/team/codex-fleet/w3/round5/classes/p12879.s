# n=5 model=out iset=I1 prefix14_class=12879
mov S1, P3
cmp P1, P2
cmovle S0, P2
cmovle P2, P1
cmovl P1, S0
cmp P3, P0
cmovl P3, P0
cmovl P0, S1
cmovg S1, P0
cmp P0, P2
cmovl P0, P2
cmovg S1, P2
cmp P3, P1
mov S1, P3
