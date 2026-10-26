# n=5 model=out iset=I1 prefix14_class=13924
cmp P1, P0
cmovle S1, P1
cmovle P1, P0
cmovl P0, S1
cmp P3, P2
mov S0, P3
cmovge P3, P2
cmovle S0, P2
mov P2, P1
cmp S0, P1
cmovge P1, S0
cmovg S0, P2
cmp P3, P0
cmovge P2, P3
