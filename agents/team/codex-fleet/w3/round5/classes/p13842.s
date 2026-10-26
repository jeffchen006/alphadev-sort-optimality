# n=5 model=out iset=I1 prefix14_class=13842
cmp P0, P2
mov S2, P0
mov S0, P3
cmovle P0, P2
cmovg S2, P2
cmp P1, S0
cmovle P3, P1
cmovg S0, P1
cmp P0, S0
cmovle S1, S0
mov P2, P3
cmovle S0, P0
cmovl P0, S1
cmp S2, P3
