# n=5 model=out iset=I1 prefix14_class=11592
mov S1, P0
cmp S1, P3
cmovl P0, P3
cmovg S1, P3
cmp P2, P1
mov S0, P2
cmovle P2, P1
cmovg S0, P1
cmp S0, S1
cmovle P1, S1
cmovle S1, S0
cmovle S0, P1
mov S1, P0
cmp P0, P2
