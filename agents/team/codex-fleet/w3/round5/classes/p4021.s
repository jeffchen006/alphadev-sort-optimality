# n=5 model=out iset=I1 prefix14_class=4021
cmp P3, P1
mov S1, P3
mov S0, P0
cmovle P3, P1
cmovge S1, P1
cmp P2, S0
cmovle P0, P2
cmovg S0, P2
cmp S1, P0
cmovl P1, S1
cmovge P1, P0
cmovle S1, P0
cmp P3, S0
mov P1, S1
