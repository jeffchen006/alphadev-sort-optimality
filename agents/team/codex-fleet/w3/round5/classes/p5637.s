# n=5 model=out iset=I1 prefix14_class=5637
cmp P1, P2
cmovg S0, P1
cmovg P1, P2
cmovle S0, P2
mov S1, P3
cmp P0, S1
cmovle S1, P0
cmovge P3, P0
cmp S1, P1
cmovge P2, P1
cmovg P1, S1
cmovg S1, P2
mov P0, S0
cmp S0, P3
