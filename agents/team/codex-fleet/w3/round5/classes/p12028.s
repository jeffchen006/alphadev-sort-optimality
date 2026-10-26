# n=5 model=out iset=I1 prefix14_class=12028
mov S0, P2
mov S1, P1
cmp S1, P3
cmovle P1, P3
cmovg S1, P3
cmp P0, P2
cmovl P2, P0
cmovle P0, S0
cmp P2, S1
mov S2, P0
cmovle P3, S1
cmovle S1, P2
cmovle P2, P3
cmp P1, P0
