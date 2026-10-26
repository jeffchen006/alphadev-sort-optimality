# n=5 model=out iset=I1 prefix14_class=10662
cmp P1, P0
mov S0, P3
cmovle S1, P0
cmovl P0, P1
cmovle P1, S1
cmp P3, P2
cmovg S0, P2
mov S2, P1
cmovge P2, P3
cmp S2, P2
cmovg S2, P2
cmovge P2, P1
mov P3, S2
cmp P0, S0
