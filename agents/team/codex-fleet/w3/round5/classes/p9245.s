# n=5 model=out iset=I1 prefix14_class=9245
cmp P3, P0
mov S0, P3
cmovg S0, P0
cmovge P0, P3
cmp P1, P2
cmovg P3, P1
cmovge P1, P2
mov S1, P1
cmovg P2, P3
cmp S1, S0
cmovle S1, S0
cmovg P1, S0
cmp P2, P0
cmovle P1, P2
