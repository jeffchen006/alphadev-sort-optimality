# n=5 model=out iset=I1 prefix14_class=3654
cmp P1, P0
mov S0, P2
cmovle S1, P1
cmovle P1, P0
cmovle P0, S1
cmp P3, S0
cmovle S0, P3
cmovl P3, P2
cmp S0, P0
mov S1, P0
cmovle S1, S0
cmovge P0, S0
cmp P3, P1
cmovg P2, P1
