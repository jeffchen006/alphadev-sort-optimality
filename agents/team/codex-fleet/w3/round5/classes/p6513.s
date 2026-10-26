# n=5 model=out iset=I1 prefix14_class=6513
cmp P3, P1
mov S1, P3
cmovg S1, P1
cmovge P1, P3
cmp P2, P0
cmovge P3, P0
cmovl P3, P2
cmovle P2, P0
mov P0, P2
cmp P1, P2
cmovl P2, P1
cmovle P1, P0
cmp S1, P3
cmovle S0, P3
