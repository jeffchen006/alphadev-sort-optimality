# n=5 model=out iset=I1 prefix14_class=9933
cmp P1, P3
cmovle S2, P1
mov S0, P2
cmovle P1, P3
cmovle P3, S2
cmp P2, P0
cmovle S0, P0
cmovl P0, P2
cmp S0, P1
cmovle P2, S0
cmovle S0, P1
cmovge P2, P1
mov S1, P3
cmp P0, P3
